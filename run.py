import os
from vunit import VUnit

# Comment out this if you have an older version of VUnit
vu = VUnit.from_argv()

# Comment in this if you have an older version of VUnit
# vu = VUnit.from_argv(compile_builtins=False)
# vu.add_vhdl_builtins()

vu.add_com()

vw_lib = vu.add_library('vw_lib')
vw_lib.add_source_files('*/*.vhd')

for tb in vw_lib.get_test_benches():

    # Load any wave.do files found in the testbench folders when running in GUI mode
    tb_folder = os.path.dirname(tb._test_bench.design_unit.file_name)
    wave_file = os.path.join(tb_folder, 'wave.do')
    if os.path.isfile(wave_file):
        tb.set_sim_option("modelsim.init_file.gui", wave_file)

    # Don't optimize away unused signals when running in GUI mode
    tb.set_sim_option("modelsim.vsim_flags.gui", ["-voptargs=+acc"])

vu.main()