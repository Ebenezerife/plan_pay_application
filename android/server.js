require('dotenv').config();
const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const PAYSTACK_URL = 'https://api.paystack.co';
const headers = {
  Authorization: `Bearer ${process.env.PAYSTACK_SECRET_KEY}`,
};

/// ✅ FETCH ALL NIGERIAN BANKS
app.get('/banks', async (req, res) => {
  try {
    const response = await axios.get(
      `${PAYSTACK_URL}/bank?country=nigeria&perPage=300`,
      { headers }
    );

    const banks = response.data.data
      .filter(b => b.active)
      .map(b => ({
        name: b.name,
        code: b.code,
      }))
      .sort((a, b) => a.name.localeCompare(b.name));

    res.json(banks);
  } catch (e) {
    res.status(500).json({ message: 'Failed to fetch banks' });
  }
});

/// ✅ RESOLVE ACCOUNT NUMBER
app.post('/resolve-account', async (req, res) => {
  const { accountNumber, bankCode } = req.body;

  try {
    const response = await axios.get(
      `${PAYSTACK_URL}/bank/resolve`,
      {
        params: {
          account_number: accountNumber,
          bank_code: bankCode,
        },
        headers,
      }
    );

    res.json({
      accountName: response.data.data.account_name,
    });
  } catch (e) {
    res.status(400).json({
      message: 'Invalid account details',
    });
  }
});

app.listen(process.env.PORT, () => {
  console.log(`Backend running on port ${process.env.PORT}`);
});
