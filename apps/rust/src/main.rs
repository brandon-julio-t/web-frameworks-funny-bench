use axum::{
    extract::{Json, Path, Query},
    response::Json as ResponseJson,
    routing::post,
    Router,
};
use serde::{Deserialize, Serialize};
use std::{collections::HashMap, env};
use validator::Validate;

#[derive(Deserialize, Validate)]
struct Request {
    #[validate(length(min = 1, max = 100))]
    name: String,
}

#[derive(Serialize)]
struct ResponseWithParams {
    id: String,
    signature: Option<String>,
    data: String,
}

async fn handle_post(
    Path(id): Path<String>,
    Query(params): Query<HashMap<String, String>>,
    Json(payload): Json<Request>,
) -> ResponseJson<ResponseWithParams> {
    ResponseJson(ResponseWithParams {
        id,
        signature: params.get("signature").cloned(),
        data: format!("Hello, \"{}\"!", payload.name),
    })
}

#[tokio::main]
async fn main() {
    let app = Router::new().route("/:id", post(handle_post));

    let port = env::var("PORT").unwrap_or_else(|_| "3000".to_string());
    let addr = format!("0.0.0.0:{}", port);

    let listener = tokio::net::TcpListener::bind(&addr).await.unwrap();
    println!("Rust server running on port {}", port);
    axum::serve(listener, app).await.unwrap();
}
