// Simple test to verify Node.js and dependencies work
require('dotenv').config();

console.log('✅ Node.js is working');
console.log('✅ dotenv loaded');
console.log('MongoDB URI:', process.env.MONGODB_URI ? '✅ Found' : '❌ Not found');
console.log('JWT Secret:', process.env.JWT_SECRET ? '✅ Found' : '❌ Not found');
console.log('Port:', process.env.PORT || 3000);

// Test MongoDB connection
const mongoose = require('mongoose');

mongoose.connect(process.env.MONGODB_URI)
  .then(() => {
    console.log('✅ MongoDB connected successfully!');
    console.log('Database name:', mongoose.connection.db.databaseName);
    process.exit(0);
  })
  .catch((error) => {
    console.error('❌ MongoDB connection failed:', error.message);
    process.exit(1);
  });

