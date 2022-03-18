use std::env;
use std::process;

use webhook::client::{WebhookClient, WebhookResult};

#[tokio::main]
async fn main() -> WebhookResult<()> {
    let response = reqwest::get("https://mikr.us/recykling.txt")
        .await?
        .text()
        .await?;

    if response != "Baza jest aktualnie pusta" {
        let url;
        match env::var("discord") {
            Ok(val) => url = val,
            Err(err) => {
                eprintln!("Erorr: {:?}", err);
                process::exit(1);
            },
        }

        let client = WebhookClient::new(&url);

        if response.contains("3.0") {
            client.send(|message| message
            .content(format!("@everyone Nowy serwer dostępny w recyklingu\n{}", response).as_str())
            .username("mikrus_recykling")
            .avatar_url("https://www.wykop.pl/cdn/c3201142/comment_pMhcEOCLm7cv7OaJ6IHjqkHE72jpX2nw.jpg")).await?;
        } else {
            client.send(|message| message
                .content(format!("Nowy serwer dostępny w recyklingu\n{}", response).as_str())
                .username("mikrus_recykling")
                .avatar_url("https://www.wykop.pl/cdn/c3201142/comment_pMhcEOCLm7cv7OaJ6IHjqkHE72jpX2nw.jpg")).await?;
        }
    }

    Ok(())
}
