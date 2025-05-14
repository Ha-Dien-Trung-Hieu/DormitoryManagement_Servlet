const socket = new WebSocket("ws://localhost:8085/dormitorymanagement_servlet/chat?studentId=" + studentId);

socket.onmessage = function(event) {
    const messages = document.getElementById("messages");
    messages.innerHTML += "<p>" + event.data + "</p>";
};

function sendMessage() {
    const input = document.getElementById("messageInput");
    socket.send(input.value);
    input.value = "";
}