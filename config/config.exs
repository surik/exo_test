# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :exo_test, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:exo_test, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

poll_interval    = 3_000
vm_memory        = ~w(erlang memory)a
memory_stats     = ~w(total processes processes_used system ets binary code atom atom_used)a
vm_processes     = ~w(erlang beam process)a
processes_stat   = ~w(process_count process_limit run_queue_size)a
vm_scheduler     = ~w(erlang beam scheduler_usage)a
scheduler_stat   = :lists.seq(1, :erlang.system_info(:schedulers))
vm_gc            = ~w(erlang beam garbage_collection)a
gc_stat          = ~w(number_of_gcs, words_reclaimed)a
vm_io            = ~w(erlang beam io)a
io_stat          = ~w(input output)a
vm_processor     = ~w(erlang beam processor)a
processor_stat   = ~w(logical_processors logical_processors_available logical_processors_online)a
vm_ports         = ~w(erlang beam port)a
ports_stat       = ~w(port_count port_limit)a
vm_uptime        = ~w(erlang beam uptime)a
uptime_stat      = ~w(value)a
vm_statistics    = ~w(erlang statistics)a
beam_stat        = ~w(run_queue)a

config :exometer_core,
  predefined: [
    {vm_memory, {:function, :erlang, :memory, [], :proplist, memory_stats}, []},
    {vm_processes, {:function, Metricman, :process_info, [], :proplist, processes_stat}, []},
    {vm_scheduler, {:function, :recon, :scheduler_usage, [1000], :proplist, scheduler_stat}, []},
    {vm_gc, {:function, Metricman, :garbage_collection, [], :value, gc_stat}, []},
    {vm_io, {:function, Metricman, :io, [], :value, io_stat}, []},
    {vm_processor, {:function, :erlang, :system_info, [:'$dp'], :value, processor_stat}, []},
    {vm_ports, {:function, :erlang, :system_info, [:'$dp'], :value, ports_stat}, []},
    {vm_uptime, {:function, Metricman, :update_uptime, [], :proplist, uptime_stat}, []},
    {vm_statistics, {:function, :erlang, :statistics, [:'$dp'], :value, beam_stat}, []},

    {[:erlang, :beam, :start_time], :gauge, []},

  ],

  report: [
    reporters: [
      exometer_report_influxdb: [
        protocol: :http,
        host: "localhost",
        port: 8086,
        db: "dev"
      ]
    ],
    subscribers: [
      {:exometer_report_influxdb, vm_memory, memory_stats, poll_interval, []},
      {:exometer_report_influxdb, vm_processes, processes_stat, poll_interval, []},
      {:exometer_report_influxdb, vm_scheduler, scheduler_stat, poll_interval, []},
      {:exometer_report_influxdb, vm_gc, gc_stat, poll_interval, []},
      {:exometer_report_influxdb, vm_io, io_stat, poll_interval, []},
      {:exometer_report_influxdb, vm_processor, processor_stat, poll_interval, []},
      {:exometer_report_influxdb, vm_ports, ports_stat, poll_interval, []},
      {:exometer_report_influxdb, vm_uptime, uptime_stat, poll_interval, []},
      {:exometer_report_influxdb, vm_statistics, beam_stat, poll_interval, []}

    ]
  ]

config :elixometer,
  reporter: :exometer_report_influxdb,
  update_frequency: 2_000,
  env: Mix.env,
  metric_prefix: "dev_api",
  subscribe_options: [{:tag, []}]
