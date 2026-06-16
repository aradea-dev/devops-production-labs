const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Endpoint utama untuk simulasi API
app.get('/api/v1/mock', (req, res) => {
    res.status(200).json({ 
        status: "OK", 
        message: "Backend is running securely with Non-Root User!" 
    });
});

// Endpoint fallback jika rute tidak ditemukan
app.use((req, res) => {
    res.status(404).json({ error: "Not Found" });
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
