defmodule Rpi4MouseUiWeb.Rpi4MouseLive do
  use Rpi4MouseUiWeb, :live_view

  require Logger

  alias Rpi4MouseUiWeb.MouseComponents

  @max_velocity_m_per_sec 0.645225

  def render(assigns) do
    ~H"""
    <div class="flex gap-x-[50px]">
      <div>
        <div class="bg-[url('../images/mouse.png')] w-[365px] h-[526px] relative">
          <MouseComponents.led0 value={@leds_values.led0} />
          <MouseComponents.led1 value={@leds_values.led1} />
          <MouseComponents.led2 value={@leds_values.led2} />
          <MouseComponents.led3 value={@leds_values.led3} />
          <MouseComponents.sw0 value={@switches_values.switch0} />
          <MouseComponents.sw1 value={@switches_values.switch1} />
          <MouseComponents.sw2 value={@switches_values.switch2} />
          <MouseComponents.light_sensors values={@light_sensors_values} />
          <MouseComponents.speed_gauge_l velocity_percent={
            to_velocity_percent(@left_motor_state.velocity)
          } />
          <MouseComponents.speed_gauge_r velocity_percent={
            to_velocity_percent(@right_motor_state.velocity)
          } />
          <MouseComponents.pwm_hz_l pwm_hz={@left_motor_state.pwm_hz} />
          <MouseComponents.pwm_hz_r pwm_hz={@right_motor_state.pwm_hz} />
          <MouseComponents.velocity_l velocity={to_velocity_cm_per_sec(@left_motor_state.velocity)} />
          <MouseComponents.velocity_r velocity={to_velocity_cm_per_sec(@right_motor_state.velocity)} />
        </div>
      </div>
      <div class="flex flex-col">
        <MouseComponents.motor_enable is_motor_enable?={@is_motor_enable?} />
        <MouseComponents.buzzer_tone busser_tone={@buzzer_tone} />
        <!--
          test.html の
          <video id="remote_video" autoplay style="border: 3px solid gray;"></video> に
          width: 350px; を加えたファイル w350.html を作成すること
        -->
        <iframe src={momo_test_src("w350.html")} class="w-[380px] h-[380px]" />
        <div class="flex">
          <a
            href={momo_test_src()}
            target="_blank"
            class="w-24 rounded m-2 p-2 bg-blue-500 text-bold text-white text-center"
          >
            Camera
          </a>
          <a
            href="/dev/dashboard"
            target="_blank"
            class="w-24 rounded m-2 p-2 bg-blue-500 text-bold text-white text-center"
          >
            Dashboard
          </a>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Rpi4MouseUi.PubSub, "Rpi4Mouse")

    initial_assigns = %{
      buzzer_tone: 0,
      is_motor_enable?: false,
      leds_values: %{led0: false, led1: false, led2: false, led3: false},
      left_motor_state: %{coeff: -1, device: nil, pwm_hz: 0, velocity: 0.0},
      light_sensors_values: %{fl: 0, fr: 0, l: 0, r: 0},
      right_motor_state: %{coeff: 1, device: nil, pwm_hz: 0, velocity: 0.0},
      switches_values: %{switch0: false, switch1: false, switch2: false}
    }

    {:ok, assign(socket, initial_assigns)}
  end

  def handle_info(
        %{
          buzzer_tone: _buzzer_tone,
          is_motor_enable?: _is_motor_enable?,
          leds_values: _leds_values,
          left_motor_state: _left_motor_state,
          light_sensors_values: _light_sensors_values,
          right_motor_state: _right_motor_state,
          switches_values: _switches_values
        } = message,
        socket
      ) do
    {:noreply, assign(socket, message)}
  end

  defp to_velocity_cm_per_sec(velocity) when is_integer(velocity) do
    to_velocity_cm_per_sec(velocity * 1.0)
  end

  defp to_velocity_cm_per_sec(velocity) when is_float(velocity) do
    round(velocity * 100)
  end

  defp to_velocity_percent(velocity) when is_integer(velocity) do
    to_velocity_percent(velocity * 1.0)
  end

  defp to_velocity_percent(velocity) when is_float(velocity) do
    round(velocity / @max_velocity_m_per_sec * 100)
  end

  defp momo_test_src(html_file_name \\ "test.html") do
    case Application.get_env(:rpi4_mouse_ui, :target, :host) do
      :host -> "http://localhost:8080/html/#{html_file_name}"
      _ -> "http://nerves.local:8080/html/#{html_file_name}"
    end
  end
end
