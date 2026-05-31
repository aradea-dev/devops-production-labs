const express = require('express');
const app = express();
const PORT = 8080;

app.get('/api/v1/health', (req, res) => {
    res.json({ status: "healthy", message: "DevOps API Tiruan Berjalan Aman!" });
});

app.listen(PORT, () => {
    console.log(`Server jalan di http://localhost:${PORT}`);
});
