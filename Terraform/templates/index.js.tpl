const counter = document.querySelector(".counter-number");
async function updateCounter() {
    let response = await fetch(
        "${lambda_url}"
    );
    let data = await response.json();
    counter.innerHTML = `👀 Page Visits: ${data}`;
}
updateCounter();