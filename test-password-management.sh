#!/bin/bash

# Password Management Testing Script
# This script helps test the password management functionality

echo "🔐 Password Management Testing Script"
echo "====================================="

# Check if we're in the right directory
if [ ! -d "doubtfire-api" ] || [ ! -d "doubtfire-web" ]; then
    echo "❌ Error: Please run this script from the doubtfire-deploy root directory"
    exit 1
fi

echo "✅ Found doubtfire-api and doubtfire-web directories"

# Test Backend
echo ""
echo "🧪 Testing Backend..."
cd doubtfire-api

# Check if Rails is available
if command -v rails &> /dev/null; then
    echo "✅ Rails found, running tests..."
    rails test test/api/password_management_test.rb
    if [ $? -eq 0 ]; then
        echo "✅ Backend tests passed!"
    else
        echo "❌ Backend tests failed!"
    fi
else
    echo "⚠️  Rails not found, skipping backend tests"
    echo "   To test manually: cd doubtfire-api && rails test test/api/password_management_test.rb"
fi

# Test Frontend
echo ""
echo "🧪 Testing Frontend..."
cd ../doubtfire-web

# Check if npm is available
if command -v npm &> /dev/null; then
    echo "✅ npm found, checking dependencies..."
    if [ -d "node_modules" ]; then
        echo "✅ Dependencies installed"
    else
        echo "⚠️  Dependencies not installed, running npm install..."
        npm install
    fi
    
    # Check for linting errors
    echo "🔍 Checking for linting errors..."
    if npm run lint &> /dev/null; then
        echo "✅ No linting errors found"
    else
        echo "⚠️  Linting errors found, run 'npm run lint' for details"
    fi
    
    # Try to build
    echo "🔨 Testing build process..."
    if npm run build &> /dev/null; then
        echo "✅ Frontend builds successfully"
    else
        echo "❌ Frontend build failed"
    fi
else
    echo "⚠️  npm not found, skipping frontend tests"
    echo "   To test manually: cd doubtfire-web && npm install && npm run build"
fi

cd ..

echo ""
echo "📋 Manual Testing Checklist"
echo "=========================="
echo ""
echo "1. Start the development servers:"
echo "   Backend:  cd doubtfire-api && rails server"
echo "   Frontend: cd doubtfire-web && ng serve"
echo ""
echo "2. Test the following URLs:"
echo "   • http://localhost:4200/register - User registration"
echo "   • http://localhost:4200/forgot-password - Password reset request"
echo "   • http://localhost:4200/sign_in - Enhanced sign-in page"
echo ""
echo "3. Test the complete flow:"
echo "   • Register a new user"
echo "   • Log in with the new account"
echo "   • Go to profile and change password"
echo "   • Request password reset via forgot password"
echo "   • Check email for reset link (in development, check log files)"
echo ""
echo "4. Check email configuration:"
echo "   • Development: Emails saved to doubtfire-api/tmp/mails"
echo "   • Production: Configure SMTP settings"
echo ""
echo "🎉 Password management system is ready for testing!"
