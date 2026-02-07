from flask import Flask, render_template, request
from datetime import datetime
import logging

app = Flask(__name__)
logging.basicConfig(level=logging.DEBUG)

# Movies with poster URLs you provided
movies = {
    "RRR": {
        "image": "https://wallpapercave.com/wp/wp13464642.jpg",
        "cast": "NTR Jr, Ram Charan, Alia Bhatt",
        "hours": "3h 7m",
        "price": 250,
        "location": "Hyderabad",
        "theatre": "PVR Cinemas"
    },
    "Animal": {
        "image": "https://wallpapercave.com/wp/wp13286327.jpg",
        "cast": "Ranbir Kapoor, Rashmika Mandanna",
        "hours": "3h 21m",
        "price": 300,
        "location": "Bangalore",
        "theatre": "INOX"
    },
    "Salaar": {
        "image": "https://wallpapercave.com/wp/wp13540561.jpg",
        "cast": "Prabhas, Prithviraj Sukumaran, Shruti Haasan",
        "hours": "2h 55m",
        "price": 280,
        "location": "Chennai",
        "theatre": "Cinepolis"
    }
}

@app.route("/")
def index():
    return render_template("index.html", movies=movies)

@app.route("/book", methods=["POST"])
def book():
    try:
        movie_name = request.form.get("movie")
        tickets = request.form.get("tickets")

        if not movie_name or not tickets:
            return "Form data missing!", 400
        if movie_name not in movies:
            return "Movie not found!", 404

        time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        return render_template(
            "book.html",
            movie=movie_name,
            tickets=tickets,
            time=time,
            movies=movies
        )
    except Exception as e:
        app.logger.error(f"Error booking movie: {e}")
        return "Internal Server Error", 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
