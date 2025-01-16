const express = require('express');
const app = express();
const PORT = process.env.PORT || 80;

app.use(express.static('public'));

app.listen(PORT, () => {
    console.log(`App running on port ${PORT}`);
});