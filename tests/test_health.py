from aceest_fitness import create_app


def test_health_endpoint_returns_ok():
    app = create_app()
    client = app.test_client()

    response = client.get("/health")
    assert response.status_code == 200
    payload = response.get_json()
    assert payload["status"] == "ok"
    assert "version" in payload
