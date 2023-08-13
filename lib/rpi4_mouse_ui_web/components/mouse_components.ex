defmodule Rpi4MouseUiWeb.MouseComponents do
  use Phoenix.Component

  def led0(assigns) do
    ~H"""
    <.led_impl location="left-[252px] top-[57px]"></.led_impl>
    """
  end

  def led1(assigns) do
    ~H"""
    <.led_impl location="left-[197px] top-[40px]"></.led_impl>
    """
  end

  def led2(assigns) do
    ~H"""
    <.led_impl location="left-[147px] top-[40px]"></.led_impl>
    """
  end

  def led3(assigns) do
    ~H"""
    <.led_impl location="left-[95px] top-[57px]"></.led_impl>
    """
  end

  def sw0(assigns) do
    ~H"""
    <.sw_impl location="left-[14px] top-[160px]"></.sw_impl>
    """
  end

  def sw1(assigns) do
    ~H"""
    <.sw_impl location="left-[14px] top-[220px]"></.sw_impl>
    """
  end

  def sw2(assigns) do
    ~H"""
    <.sw_impl location="left-[14px] top-[280px]"></.sw_impl>
    """
  end

  def light_sensors(assigns) do
    ~H"""
    <.light_sensor location="left-[-30px] top-[50px]"><%= @values.fl %></.light_sensor>
    <.light_sensor location="left-[90px] top-[0px]"><%= @values.l %></.light_sensor>
    <.light_sensor location="right-[90px] top-[0px]"><%= @values.r %></.light_sensor>
    <.light_sensor location="right-[-30px] top-[50px]"><%= @values.fr %></.light_sensor>
    """
  end

  def light_sensor(assigns) do
    ~H"""
    <div class={[
      "w-[60px]",
      "font-bold font-mono text-2xl text-yellow-500 text-right absolute",
      @location
    ]}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def speed_gauge_l(assigns) do
    ~H"""
    <.speed_gauge_impl
      location="top-[250px] left-[0px] -translate-x-full"
      height={"#{to_height_px(@velocity)}"}
      top={"#{to_top_px(@velocity)}"}
      bg_color={"#{to_color(@velocity)}"}
    />
    """
  end

  def speed_gauge_r(assigns) do
    ~H"""
    <.speed_gauge_impl
      location="top-[250px] right-[0px] translate-x-full"
      height={"#{to_height_px(@velocity)}"}
      top={"#{to_top_px(@velocity)}"}
      bg_color={"#{to_color(@velocity)}"}
    />
    """
  end

  defp speed_gauge_impl(assigns) do
    ~H"""
    <div
      class={["absolute w-[30px] bg-green-500", @location]}
      style={["height: #{@height}; top: #{@top}; background-color: #{@bg_color}"]}
    >
    </div>
    """
  end

  defp to_height_px(velocity) do
    "#{round(abs(velocity) / 26.9 * 150)}px"
  end

  defp to_top_px(velocity) do
    if velocity > 0 do
      "#{250 - round(abs(velocity) / 26.9 * 150)}px"
    else
      "250 px"
    end
  end

  defp to_color(velocity) do
    if velocity > 0, do: "rgb(37 99 235)", else: "rgb(220 38 38)"
  end

  def pwm_hz_l(assigns) do
    ~H"""
    <.pwm_hz_impl location="bottom-[0px] left-[0px] -translate-x-1/2">
      <%= @pwm_hz %>
    </.pwm_hz_impl>
    """
  end

  def pwm_hz_r(assigns) do
    ~H"""
    <.pwm_hz_impl location="bottom-[0px] right-[0px] translate-x-1/2">
      <%= @pwm_hz %>
    </.pwm_hz_impl>
    """
  end

  def velocity_l(assigns) do
    ~H"""
    <.velocity_impl location="bottom-[0px] left-[0px] -translate-x-1/2 translate-y-1/2">
      <%= @velocity %>
    </.velocity_impl>
    """
  end

  def velocity_r(assigns) do
    ~H"""
    <.velocity_impl location="bottom-[0px] right-[0px] translate-x-1/2 translate-y-1/2">
      <%= @velocity %>
    </.velocity_impl>
    """
  end

  def motor_enable(assigns) do
    ~H"""
    <div class={["w-[250px] h-[50px] text-black font-mono font-bold text-2xl grid grid-cols-2"]}>
      <p class="text-left">Motor</p>
      <%= if @is_motor_enable? do %>
        <p class="text-right text-green-500">Enable</p>
      <% else %>
        <p class="text-right text-red-500">Disable</p>
      <% end %>
    </div>
    """
  end

  def buzzer_tone(assigns) do
    ~H"""
    <div class={["w-[250px] h-[50px] text-black font-mono font-bold text-2xl grid grid-cols-2"]}>
      <p class="text-left">Buzzer</p>
      <p class="text-right"><%= @busser_tone %> Hz</p>
    </div>
    """
  end

  defp velocity_impl(assigns) do
    ~H"""
    <div class={[
      "absolute w-[178px] h-[50px]",
      "font-bold font-mono text-black text-2xl text-center",
      "flex flex-col justify-center",
      @location
    ]}>
      <%= render_slot(@inner_block) %> m/s
    </div>
    """
  end

  defp pwm_hz_impl(assigns) do
    ~H"""
    <div class={[
      "absolute w-[178px] h-[50px]",
      "font-bold font-mono text-black text-2xl text-center",
      "flex flex-col justify-center",
      @location
    ]}>
      <%= render_slot(@inner_block) %> Hz
    </div>
    """
  end

  defp led_impl(assigns) do
    ~H"""
    <div class={["rounded-full w-[20px] h-[20px] bg-red-500 absolute", @location]}></div>
    """
  end

  defp sw_impl(assigns) do
    ~H"""
    <div class={["rounded-full w-[20px] h-[20px] bg-blue-500 absolute", @location]}></div>
    """
  end
end
