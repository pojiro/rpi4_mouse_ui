defmodule Rpi4MouseUiWeb.Rpi4MouseLive do
  use Rpi4MouseUiWeb, :live_view

  require Logger

  alias Rpi4MouseUiWeb.MouseComponents

  def render(assigns) do
    ~H"""
    <div class="flex">
      <div class="w-[365px] h-[526px] mr-[70px]">
        <div class="bg-[url('../images/mouse.png')] w-full h-full relative">
          <MouseComponents.led3></MouseComponents.led3>
          <MouseComponents.led2></MouseComponents.led2>
          <MouseComponents.led1></MouseComponents.led1>
          <MouseComponents.led0></MouseComponents.led0>
          <MouseComponents.sw0></MouseComponents.sw0>
          <MouseComponents.sw1></MouseComponents.sw1>
          <MouseComponents.sw2></MouseComponents.sw2>
          <MouseComponents.light_sensors values={@light_sensors_values} />
          <MouseComponents.speed_gauge_l></MouseComponents.speed_gauge_l>
          <MouseComponents.speed_gauge_r></MouseComponents.speed_gauge_r>
          <MouseComponents.pwm_hz_l pwm_hz={@left_motor_state.pwm_hz} />
          <MouseComponents.pwm_hz_r pwm_hz={@right_motor_state.pwm_hz} />
          <MouseComponents.velocity_l velocity={@left_motor_state.velocity} />
          <MouseComponents.velocity_r velocity={@right_motor_state.velocity} />
        </div>
      </div>
      <div class="flex flex-col">
        <MouseComponents.motor_enable is_motor_enable?={@is_motor_enable?} />
        <MouseComponents.buzzer_tone busser_tone={@buzzer_tone} />
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Rpi4MouseUi.PubSub, "Rpi4Mouse")

    initial_assigns = %{
      buzzer_tone: 0,
      is_motor_enable?: false,
      left_motor_state: %{coeff: -1, device: nil, pwm_hz: 0, velocity: 0},
      light_sensors_values: %{fl: 0, fr: 0, l: 0, r: 0},
      right_motor_state: %{coeff: 1, device: nil, pwm_hz: 0, velocity: 0}
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
end
