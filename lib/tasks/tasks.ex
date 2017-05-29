defmodule :digital_signature_tasks do
  @moduledoc """
  Nice way to apply migrations inside a released application.
  Example:
      digital_signature.api/bin/digital_signature_api command digital_signature_tasks migrate!
  """

  def migrate! do
    migrations_dir = Path.join(["priv", "repo", "migrations"])

    repo = DigitalSignature.Repo

    repo
    |> start_repo
    |> Ecto.Migrator.run(migrations_dir, :up, all: true)

    System.halt(0)
    :init.stop()
  end

  defp start_repo(repo) do
    load_app()
    repo.start_link()
    repo
  end

  defp load_app do
    start_applications([:logger, :postgrex, :ecto])
    :ok = Application.load(:digital_signature_api)
  end

  defp start_applications(apps) do
    Enum.each(apps, fn app ->
      {_ , _message} = Application.ensure_all_started(app)
    end)
  end
