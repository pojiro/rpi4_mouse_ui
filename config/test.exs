import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rpi4_mouse_ui, Rpi4MouseUiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "76342YS90guy+BAVKGwXTrDgWX3FufoJC2pVHJmQrMADM6Og0nSniuienz0e0p04",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
