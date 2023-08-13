defmodule Rpi4MouseUiWeb.Rpi4MouseLive do
  use Rpi4MouseUiWeb, :live_view

  require Logger

  alias Rpi4MouseUiWeb.MouseComponents

  def render(assigns) do
    ~H"""
    <div class="flex gap-x-[50px]">
      <div>
        <div class="bg-[url('../images/mouse.png')] w-[365px] h-[526px] relative">
          <MouseComponents.led3></MouseComponents.led3>
          <MouseComponents.led2></MouseComponents.led2>
          <MouseComponents.led1></MouseComponents.led1>
          <MouseComponents.led0></MouseComponents.led0>
          <MouseComponents.sw0></MouseComponents.sw0>
          <MouseComponents.sw1></MouseComponents.sw1>
          <MouseComponents.sw2></MouseComponents.sw2>
          <MouseComponents.light_sensors values={@light_sensors_values} />
          <MouseComponents.speed_gauge_l velocity={round_velocity(@left_motor_state.velocity)} />
          <MouseComponents.speed_gauge_r velocity={round_velocity(@right_motor_state.velocity)} />
          <MouseComponents.pwm_hz_l pwm_hz={@left_motor_state.pwm_hz} />
          <MouseComponents.pwm_hz_r pwm_hz={@right_motor_state.pwm_hz} />
          <MouseComponents.velocity_l velocity={round_velocity(@left_motor_state.velocity)} />
          <MouseComponents.velocity_r velocity={round_velocity(@right_motor_state.velocity)} />
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
        <a
          href={momo_test_src()}
          target="_blank"
          class="w-24 rounded mt-2 p-2 bg-blue-500 text-bold text-white text-center self-end"
        >
          Open Tab
        </a>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Rpi4MouseUi.PubSub, "Rpi4Mouse")

    initial_assigns = %{
      buzzer_tone: 0,
      is_motor_enable?: false,
      left_motor_state: %{coeff: -1, device: nil, pwm_hz: 0, velocity: 0.0},
      light_sensors_values: %{fl: 0, fr: 0, l: 0, r: 0},
      right_motor_state: %{coeff: 1, device: nil, pwm_hz: 0, velocity: 0.0}
    }

    {:ok, assign(socket, initial_assigns)}
  end

  def handle_info(
        %{
          buzzer_tone: _buzzer_tone,
          is_motor_enable?: _is_motor_enable?,
          left_motor_state: _left_motor_state,
          light_sensors_values: _light_sensors_values,
          right_motor_state: _right_motor_state
        } = message,
        socket
      ) do
    {:noreply, assign(socket, message)}
  end

  defp round_velocity(velocity) when is_integer(velocity) do
    0.0
  end

  defp round_velocity(velocity) when is_float(velocity) do
    Float.round(velocity, 1)
  end

  defp momo_test_src(html_file_name \\ "test.html") do
    case :inet.gethostbyname(~c"nerves.local") do
      {:ok, {:hostent, ~c"nerves.local", [], :inet, 4, [{127, 0, 0, 1}]}} ->
        "http://nerves.local:8080/html/#{html_file_name}"

      _ ->
        "http://localhost:8080/html/#{html_file_name}"
    end
  end
end
