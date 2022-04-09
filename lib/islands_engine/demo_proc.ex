defmodule IslandsEngine.DemoProc do
  def loop() do
    receive do
      message ->
        IO.puts("Message: #{message}")
    end
    loop()
  end
end
