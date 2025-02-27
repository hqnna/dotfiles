{ config, lib, pkgs, ... }:

{
  programs.btop = {
    enable = true;

    settings = {
      color_theme = "onedark";
      theme_background = false;
      truecolor = true;
      force_tty = false;
      presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
      vim_keys = false;
      rounded_corners = true;
      graph_symbol = "braille";
      graph_symbol_cpu = "default";
      graph_symbol_gpu = "default";
      graph_symbol_mem = "default";
      graph_symbol_net = "default";
      graph_symbol_proc = "default";
      shown_boxes = "mem net proc cpu";
      update_ms = 1000;
      proc_sorting = "cpu lazy";
      proc_reversed = false;
      proc_tree = false;
      proc_colors = true;
      proc_gradient = true;
      proc_peer_core = false;
      proc_mem_bytes = true;
      proc_cpu_graphs = true;
      proc_info_smaps = false;
      proc_left = false;
      proc_filter_kernel = false;
      proc_aggregate = false;
      cpu_graph_upper = "Auto";
      cpu_graph_lower = "Auto";
      show_gpu_info = "Auto";
      cpu_invert_lower = true;
      cpu_single_graph = false;
      cpu_bottom = false;
      show_uptime = true;
      check_temp = true;
      cpu_sensor = "Auto";
      show_coretemp = true;
      cpu_core_map = "";
      temp_scale = "celsius";
      base_10_sizes = true;
      show_cpu_freq = true;
      clock_format = "%X";
      background_update = true;
      mem_graphs = true;
      mem_below_net = false;
      show_swap = true;
      swap_disk = true;
      show_disks = true;
      only_physical = true;
      use_fstab = false;
      show_ui_stat = true;
      net_auto = true;
      net_sync = true;
      show_battery = false;
      log_level = "DISABLED";
      nvml_measure_pcie_speeds = true;
      gpu_mirror_graph = true;
    };
  };
}
