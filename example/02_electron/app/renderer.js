const button = document.querySelector(".alert");;
const links = document.querySelector(".links");;
const error_message = document.querySelector(".error-message");;
const new_link_form = document.querySelector(".new-link-form");;
const new_link_url = document.querySelector(".new-link-url");;
const new_link_submit = document.querySelector(".new-link-submit");;
const clear_storage = document.querySelector(".clear-storage");;
const clearForm = function() {
    new_link_url = null;
};;
new_link_url.addEventListener("keyup", function() {
    new_link_submit.disabled = !new_link_url;
});
new_link_form.addEventListener("submit", function(event) {
    event.preventDefault();
    const url = new_link_url.value;;
    fetch(url).then(function(response) {
        return response.text();
    });;
});
button.addEventListener("click", function() {
    alert("bla");
});