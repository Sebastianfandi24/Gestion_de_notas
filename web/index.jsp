<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Mensaje Especial</title>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&family=Dancing+Script:wght@700&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Montserrat', sans-serif;
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                margin: 0;
                padding: 0;
                height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                overflow: hidden;
            }
            .container {
                text-align: center;
                background-color: rgba(255, 255, 255, 0.9);
                border-radius: 15px;
                padding: 40px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                max-width: 800px;
                width: 90%;
                position: relative;
                overflow: hidden;
            }
            h1 {
                font-family: 'Dancing Script', cursive;
                font-size: 5rem;
                color: #e74c3c;
                margin-bottom: 30px;
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
            }
            .heart {
                position: absolute;
                pointer-events: none;
                animation: float 6s ease-in-out infinite;
                opacity: 0.7;
            }
            @keyframes float {
                0% { transform: translateY(0) rotate(0deg); 
                50% { transform: translateY(-20px) rotate(5deg); 
                100% { transform: translateY(0) rotate(0deg); 
            }
            .subtitle {
                font-size: 1.5rem;
                color: #555;
                margin-top: 20px;
            }
            .decoration {
                position: absolute;
                width: 100%;
                height: 5px;
                background: linear-gradient(90deg, #e74c3c, #ff9a8b, #e74c3c);
                bottom: 0;
                left: 0;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>TE AMO MIGUE</h1>
            <p class="subtitle">Con todo mi corazón, hoy y siempre</p>
            <div class="decoration"></div>
            
            <svg class="heart" style="top: 10%; left: 10%; width: 40px;" viewBox="0 0 32 32" fill="#e74c3c">
                <path d="M16,28.261c0,0-14-7.926-14-17.046c0-9.356,13.159-10.399,14-0.454c1.011-9.938,14-8.903,14,0.454
                C30,20.335,16,28.261,16,28.261z"/>
            </svg>
            <svg class="heart" style="top: 15%; right: 15%; width: 30px; animation-delay: 1s;" viewBox="0 0 32 32" fill="#e74c3c">
                <path d="M16,28.261c0,0-14-7.926-14-17.046c0-9.356,13.159-10.399,14-0.454c1.011-9.938,14-8.903,14,0.454
                C30,20.335,16,28.261,16,28.261z"/>
            </svg>
            <svg class="heart" style="bottom: 20%; left: 20%; width: 25px; animation-delay: 2s;" viewBox="0 0 32 32" fill="#e74c3c">
                <path d="M16,28.261c0,0-14-7.926-14-17.046c0-9.356,13.159-10.399,14-0.454c1.011-9.938,14-8.903,14,0.454
                C30,20.335,16,28.261,16,28.261z"/>
            </svg>
        </div>
    </body>
</html>
