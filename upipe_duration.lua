#!/usr/bin/env luajit

local ev = require "libev"
local ffi = require "ffi"
local upipe = require "upipe"

ffi.cdef [[ FILE *stderr; ]]

local UPROBE_LOG_LEVEL = UPROBE_LOG_NOTICE
local UMEM_POOL = 512
local UDICT_POOL_DEPTH = 500
local UREF_POOL_DEPTH = 500
local UBUF_POOL_DEPTH = 3000
local UBUF_SHARED_POOL_DEPTH = 50
local UPUMP_POOL = 10
local UPUMP_BLOCKER_POOL = 10

local count_mgr = upipe.mgr {
    init = function (pipe)
	pipe.props.duration = 0
    end,

    input = function (pipe, ref, pump)
	local duration = ffi.new("uint64_t[1]")
	if ubase_check(ref:clock_get_duration(duration)) then
	    pipe.props.duration = pipe.props.duration + tonumber(duration[0])
	end
	ref:free()
    end,

    control = function (pipe, command, args)
	if command == UPIPE_SET_FLOW_DEF then
	    return UBASE_ERR_NONE
	end
	return UBASE_ERR_UNHANDLED
    end
}

local file = assert(arg[1])
local loop = ffi.gc(ev_default_loop(0), ev_loop_destroy)

-- managers
local upump_mgr = upump.ev(loop, UPUMP_POOL, UPUMP_BLOCKER_POOL)
local umem_mgr = umem.pool_simple(UMEM_POOL)
local udict_mgr = udict.inline(UDICT_POOL_DEPTH, umem_mgr, -1, -1)
local uref_mgr = uref.std(UREF_POOL_DEPTH, udict_mgr, 0)

-- probes
local probe =
    uprobe.ubuf_mem(umem_mgr, UBUF_POOL_DEPTH, UBUF_SHARED_POOL_DEPTH) ..
    uprobe.upump_mgr(upump_mgr) ..
    uprobe.uref_mgr(uref_mgr) ..
    uprobe.stdio(ffi.C.stderr, UPROBE_LOG_LEVEL)

-- pipes
local sink = count_mgr:new()

local src = upipe.fsrc():new(uprobe.pfx(UPROBE_LOG_LEVEL, "fsrc") .. probe)
if not ubase_check(src:set_uri(file)) then
    io.stderr:write("invalid file\n")
    os.exit(1)
end

local ts_demux_mgr = upipe.ts_demux()
ts_demux_mgr.mpgvf_mgr = upipe.mpgvf()
ts_demux_mgr.h264f_mgr = upipe.h264f()

src.output = ts_demux_mgr:new(
    uprobe.pfx(UPROBE_LOG_LEVEL, "ts demux") ..
    uprobe.selflow(UPROBE_SELFLOW_VOID, "auto",
	uprobe.selflow(UPROBE_SELFLOW_PIC, "auto",
	    uprobe {
		NEW_FLOW_DEF = function (probe, pipe, args)
		    pipe.output = sink
		end } ..
	    probe) ..
	probe) ..
    probe)

-- main loop
ev_run(loop, 0)

print(string.format("%.2f", sink.props.duration / UCLOCK_FREQ))
