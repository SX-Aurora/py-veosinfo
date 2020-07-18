from _veosinfo import cpu_info


ve_cpu_info_cache = dict()


def calc_metrics(nodeid, old, new):
    """
    Calculate metrics from two perf counter values dicts.
    nodeid needs to be passed in order to have the correct value of the clock.
    The result is stored in a dict with keys being the metric names.

    MOPS                = (EX-VX+VE+FMAEC) / USRCC*clck
    MFLOPS              = FPEC/USRCC*clck
    V.OP RATIO          = VE/(EX-VX+VE)*100
    AVER. V.LEN     [-] = VE/VX
    VECTOR TIME         = VECC/1.4GHz
    L1CACHE MISS        = L1MCC/1.4GHz
    CPU PORT CONF       = PCCC/1.4GHz
    VLD LLC HIT E   [%] = (1-VLCME/VLEC)*100

    LOAD BW [Byte/s]      = LTRC*4/(USRCC/1.4GHz)
    STORE BW [Byte/s]     = STRC*4/(USRCC/1.4GHz)

    """
    global ve_cpu_info_cache
    r = dict()
    if nodeid not in ve_cpu_info_cache:
        ve_cpu_info_cache[nodeid] = cpu_info(nodeid)
    clck = float(ve_cpu_info_cache[nodeid]['mhz'])
    clck_hz = clck * 1000000
    clck_ghz = clck / 1000
    for _r in ["EX", "VX", "VE", "FMAEC", "FPEC", "USRCC", "VECC",
               "L1MCC", "PCCC", "VLCME", "VLEC", "LTRC", "STRC", "T"]:
        exec("d%s = float(new.get(\"%s\", 0) - old.get(\"%s\", 0))" % (_r, _r, _r))
        #exec("print \"d%s=%%r new %s=%%r old %s=%%r\" %% (d%s, new.get(\"%s\", 0), old.get(\"%s\", 0))" %
        #     (_r, _r, _r, _r, _r, _r))


    r["USRSEC"] = new.get("USRCC", 0) / clck_hz
    r["USRTIME"] = dUSRCC / clck_hz
    r["ELAPSED"] = dT

    if r["ELAPSED"] > 0:
        r["EFFTIME"] = r["USRTIME"] / r["ELAPSED"]

    if dUSRCC > 0:
        r["MOPS"] = (dEX - dVX + dVE + dFMAEC) * clck / dUSRCC
        r["MFLOPS"] = dFPEC * clck / dUSRCC
        r["VTIMERATIO"] = dVECC * 100 / dUSRCC
        r["L1CACHEMISS"] = dL1MCC * 100 / dUSRCC
        r["CPUPORTCONF"] = dPCCC * 100 / dUSRCC

    if dEX > 0:
        r["VOPRAT"] = dVE * 100 / (dEX - dVX + dVE)

    if dVX > 0:
        r["AVGVL"] = dVE / dVX

    if dVLEC > 0:
        r["VLDLLCHIT"] = (1 - dVLCME / dVLEC) * 100

    if dLTRC > 0:
        r["LOADBW"] = (dLTRC * 4) / (dUSRCC / clck_ghz)

    if dSTRC > 0:
        r["STOREBW"] = (dSTRC * 4) / (dUSRCC / clck_ghz)

    return r
