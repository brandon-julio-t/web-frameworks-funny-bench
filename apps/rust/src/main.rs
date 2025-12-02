use axum::{
    extract::Json,
    http::StatusCode,
    response::Json as ResponseJson,
    routing::post,
    Router,
};
use serde::{Deserialize, Serialize};
use std::env;
use validator::Validate;

#[derive(Deserialize, Validate)]
struct Request {
    #[validate(length(min = 1, max = 100))]
    name: String,
}

#[derive(Serialize)]
struct Response {
    data: String,
}

#[derive(Serialize)]
struct ErrorResponse {
    error: String,
}

async fn handle_post(Json(payload): Json<Request>) -> ResponseJson<Response> {
    ResponseJson(Response {
        data: format!("Hello, \"{}\"!", payload.name),
    })
}

#[tokio::main]
async fn main() {
    let app = Router::new().route("/", post(handle_post));

    let port = env::var("PORT").unwrap_or_else(|_| "3000".to_string());
    let addr = format!("0.0.0.0:{}", port);

    let listener = tokio::net::TcpListener::bind(&addr).await.unwrap();
    println!("Rust server running on port {}", port);
    axum::serve(listener, app).await.unwrap();
}
