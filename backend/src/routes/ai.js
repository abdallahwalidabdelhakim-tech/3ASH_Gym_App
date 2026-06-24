/**
 * AI Routes for image analysis using Hugging Face API.
 * Currently supports food image recognition for calorie estimation.
 */

const express = require('express');
const authenticateToken = require('../middleware/auth');

const router = express.Router();

// Hugging Face API endpoint for food image classification
const HF_MODEL_URL = "https://router.huggingface.co/hf-inference/models/nateraw/food";

/**
 * Analyzes a food image using Hugging Face API for classification.
 * @route POST /api/ai/food
 * @access Protected (requires JWT token)
 * @param {string} req.body.image - Base64 encoded image string
 * @returns {Object} Classification results with labels and scores
 */
router.post('/food', authenticateToken, async (req, res) => {
    try {
        const { image } = req.body; // Expecting base64 string (clean, no data:image/... prefix)

        // Validate image data
        if (!image) {
            return res.status(400).json({ success: false, message: 'Image data is required' });
        }

        // Prepare request headers
        const headers = {
            "Content-Type": "application/json",
        };

        // Add Hugging Face API token if available
        if (process.env.HF_API_TOKEN) {
            headers["Authorization"] = `Bearer ${process.env.HF_API_TOKEN}`;
        }

        // Send image to Hugging Face API for classification
        const response = await fetch(HF_MODEL_URL, {
            method: "POST",
            headers: headers,
            body: JSON.stringify({ inputs: image }),
        });

        // Handle API errors
        if (!response.ok) {
            const errorText = await response.text();
            console.error('Hugging Face API Error:', response.status, errorText);
            return res.status(response.status).json({ 
                success: false, 
                message: 'Error from AI service', 
                details: errorText 
            });
        }

        const result = await response.json();

        // Result format: [{ label: "pizza", score: 0.99 }, ...]
        res.json({ success: true, predictions: result });

    } catch (error) {
        console.error('AI Processing Error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

module.exports = router;
