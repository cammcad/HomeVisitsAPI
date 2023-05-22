defmodule HomeVisitsApi.DefaultImpl.Validations do
  @moduledoc false

  @valid_email_regex ~r/^[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+$/i

  def valid_email?(email), do: Regex.match?(@valid_email_regex, email)
end
