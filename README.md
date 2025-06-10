# Project Setup and Running Instructions

This document provides instructions to download, set up, and run the project, which consists of a backend Django application and a frontend React application.

---

## Prerequisites

- Python 3.x installed on your system
- Node.js and npm installed on your system
- Git (to clone the repository)

---

## Backend Setup (Django)

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd <repository-folder>/backend
   ```

2. **Create and activate a virtual environment**

   On Windows:

   ```bash
   python -m venv venv
   venv\Scripts\activate
   ```

   On macOS/Linux:

   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

3. **Install Python dependencies**

   Install the required Python dependencies using the provided `requirements.txt` file:

   ```bash
   pip install -r requirements.txt
   ```

4. **Set up environment variables**

   The project uses a `.env` file for environment variables. Please create a `.env` file in the `backend` directory with the necessary variables. You can refer to the existing `.env` file (not included in the repository for security reasons) for required variables such as database credentials, secret keys, etc.

5. **Set up the database**

   If you are using a database, you can set it up using the provided `database_schema.sql` file:

   - Import the `database_schema.sql` into your database server.
   - Alternatively, run Django migrations if applicable:

   ```bash
   python manage.py migrate
   ```

6. **Run the backend server**

   ```bash
   python manage.py runserver
   ```

   The backend server will start running at `http://127.0.0.1:8000/`.

---

## Frontend Setup (React)

1. **Navigate to the frontend directory**

   ```bash
   cd ../job
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

   The main frontend dependencies used in this project include:
   - react
   - react-dom
   - react-router-dom
   - axios
   - styled-components
   - react-quill
   - react-paginate
   - recharts
   - validator
   - @fortawesome/fontawesome-free
   - html2canvas
   - html2pdf.js
   - jspdf
   - moment

3. **Run the frontend development server**

   ```bash
   npm start
   ```

   The frontend will start running at `http://localhost:3000/`.

---

## Accessing the Application

- Backend API: `http://127.0.0.1:8000/`
- Frontend UI: `http://localhost:3000/`

Make sure both backend and frontend servers are running to use the full application.

---

## Additional Notes

- The `media/` folder in the backend directory is used for storing uploaded files.
- Ensure your `.env` file contains all necessary environment variables for the backend to function properly.
- If you encounter any issues, please check that all dependencies are installed and environment variables are correctly set.

---

Thank you for using this project!
