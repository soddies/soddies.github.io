document.getElementById('sendButton').addEventListener('click', function() {
    const messageInput = document.getElementById('messageInput');
    const senderInput = document.getElementById('senderInput');
    const messages = document.getElementById('messages');
    const userMessages = document.getElementById('userMessages');

    const messageText = messageInput.value;
    const senderText = senderInput.value;

    if (messageText && senderText) {
        const messageElement = document.createElement('div');
        messageElement.className = 'message';
        messageElement.innerText = `${senderText}: ${messageText}`;

        messages.appendChild(messageElement);
        userMessages.appendChild(messageElement.cloneNode(true));

        messageInput.value = '';
        senderInput.value = '';

        messages.scrollTop = messages.scrollHeight;
        userMessages.scrollTop = userMessages.scrollHeight;
    }
});

