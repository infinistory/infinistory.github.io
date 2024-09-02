<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Interactive Storyline</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            padding: 20px;
            max-width: 600px;
            margin: 0 auto;
        }
        #story {
            border: 1px solid #ddd;
            background-color: #fff;
            padding: 20px;
            min-height: 200px;
            margin-bottom: 20px;
        }
        #addSentence {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
        }
        button {
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            border: none;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        .cooldown, .resetMessage {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>

<h1>Interactive Storyline</h1>
<div id="story">
    <p id="storyContent">Once upon a time...</p>
</div>

<input type="text" id="addSentence" placeholder="Add up to 20 characters..." maxlength="20">
<button onclick="addToStory()">Add to Story</button>
<p id="cooldownMessage" class="cooldown"></p>
<p id="countdownTimer"></p>

<script>
    const cooldownPeriod = 60 * 1000; // 1 minute cooldown period in milliseconds
    const bypassCode = '>:3';
    const resetCode = '@imaboykisser@';
    const cooldownMessage = document.getElementById('cooldownMessage');
    const countdownTimer = document.getElementById('countdownTimer');
    let cooldownEndTime = localStorage.getItem('cooldownEndTime') || 0;

    function updateCountdown() {
        const currentTime = new Date().getTime();
        if (cooldownEndTime > currentTime) {
            const remainingTime = Math.ceil((cooldownEndTime - currentTime) / 1000);
            countdownTimer.textContent = `Cooldown: ${remainingTime} seconds remaining.`;
            setTimeout(updateCountdown, 1000); // Update every second
        } else {
            countdownTimer.textContent = '';
        }
    }

    function addToStory() {
        const input = document.getElementById('addSentence');
        const storyContent = document.getElementById('storyContent');
        const currentTime = new Date().getTime();
        const sentence = input.value.trim();

        if (sentence === bypassCode) {
            localStorage.removeItem('cooldownEndTime');
            cooldownEndTime = 0;
            cooldownMessage.textContent = '';
            input.value = '';
            updateCountdown();
            return;
        }

        if (sentence === resetCode) {
            localStorage.removeItem('story');
            localStorage.removeItem('cooldownEndTime');
            storyContent.innerHTML = 'Once upon a time...';
            input.value = '';
            cooldownMessage.textContent = '';
            countdownTimer.textContent = '';
            return;
        }

        if (cooldownEndTime && currentTime < cooldownEndTime) {
            const remainingTime = Math.ceil((cooldownEndTime - currentTime) / 1000);
            cooldownMessage.textContent = `Please wait ${remainingTime} seconds before adding another sentence.`;
            return;
        }

        if (sentence.length > 0 && sentence.length <= 20) {
            storyContent.innerHTML += ' ' + sentence;
            localStorage.setItem('story', storyContent.innerHTML);
            localStorage.setItem('lastAddedTime', currentTime);
            cooldownEndTime = currentTime + cooldownPeriod;
            localStorage.setItem('cooldownEndTime', cooldownEndTime);
            input.value = '';
            cooldownMessage.textContent = '';
            updateCountdown();
        } else if (sentence.length > 20) {
            cooldownMessage.textContent = 'You can only add up to 20 characters at a time.';
        }
    }

    document.addEventListener('DOMContentLoaded', () => {
        const savedStory = localStorage.getItem('story');
        const storyContent = document.getElementById('storyContent');
        if (savedStory) {
            storyContent.innerHTML = savedStory;
        }
        updateCountdown();
    });
</script>

</body>
</html>
