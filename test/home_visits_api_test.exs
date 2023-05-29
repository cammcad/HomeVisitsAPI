defmodule HomeVisitsApiTest do
  use ExUnit.Case

  alias HomeVisitsApi.Request
  alias HomeVisitsApi.Fulfill
  import Ecto.Query

  setup do
    HomeVisitsApi.Repo.put_dynamic_repo(HomeVisitsApiTest.Repo)
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(HomeVisitsApi.Repo)
  end

  test "Create User - Member" do
    george = %Schema.User{
      first_name: "George",
      last_name: "Costanza",
      email: "george.costanza@gmail.com",
      roles: ["member"]
    }

    {:ok, user} = HomeVisitsApi.create_user(george)

    assert user.first_name == "George"
    assert user.last_name == "Costanza"
    assert user.email == "george.costanza@gmail.com"
    assert user.roles == ["member"]
  end

  test "Create User - Pal" do
    jerry = %Schema.User{
      first_name: "Jerry",
      last_name: "Seinfeld",
      email: "jerry.seinfeld@gmail.com",
      roles: ["pal"]
    }

    {:ok, user} = HomeVisitsApi.create_user(jerry)

    HomeVisitsApi.Repo.all(from(u in Schema.User, select: u))
    assert user.first_name == "Jerry"
    assert user.last_name == "Seinfeld"
    assert user.email == "jerry.seinfeld@gmail.com"
    assert user.roles == ["pal"]
  end

  test "Request Visit" do
    george = %Schema.User{
      first_name: "George",
      last_name: "Costanza",
      email: "george.costanza@gmail.com",
      roles: ["member"]
    }

    {:ok, user} = HomeVisitsApi.create_user(george)

    visit_request = %Request{
      email: george.email,
      date: Date.from_iso8601!("2023-10-08"),
      minutes: 30.0,
      tasks: ["coffee chat"]
    }

    {:ok, :request_pending} = HomeVisitsApi.request_visit(visit_request)

    [visit] = HomeVisitsApi.Repo.all(from(v in Schema.Visit, select: v))
    assert visit.minutes == visit_request.minutes
    assert visit.date == visit_request.date
    assert visit.tasks == visit_request.tasks
  end

  test "Fulfill Visit" do
    george = %Schema.User{
      first_name: "George",
      last_name: "Costanza",
      email: "george.costanza@gmail.com",
      roles: ["member"]
    }

    {:ok, user_george} = HomeVisitsApi.create_user(george)

    jerry = %Schema.User{
      first_name: "Jerry",
      last_name: "Seinfeld",
      email: "jerry.seinfeld@gmail.com",
      roles: ["pal"]
    }

    {:ok, user_jerry} = HomeVisitsApi.create_user(jerry)

    visit_request = %Request{
      email: george.email,
      date: Date.from_iso8601!("2023-10-08"),
      minutes: 30.0,
      tasks: ["coffee chat"]
    }

    {:ok, :request_pending} = HomeVisitsApi.request_visit(visit_request)

    [visit] = HomeVisitsApi.Repo.all(from(v in Schema.Visit, select: v))

    fulfillment = %Fulfill{
      id: visit.uuid,
      email: user_jerry.email
    }

    {:ok, :fulfilled} = HomeVisitsApi.fulfill_visit(fulfillment)

    db_jerry = HomeVisitsApi.Repo.get_by(Schema.User, email: user_jerry.email)
    db_george = HomeVisitsApi.Repo.get_by(Schema.User, email: user_george.email)
    [transaction] = HomeVisitsApi.Repo.all(from(t in Schema.Transaction, select: t))

    assert transaction.member_id == db_george.uuid
    assert transaction.pal_id == db_jerry.uuid
    assert transaction.visit_id == visit.uuid
  end
end
