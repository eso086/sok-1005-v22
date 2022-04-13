from pywebio.input import *
from pywebio.output import *

input("What is your name?")
select("choose you favorite hobby", ['Football ', 'Golf', 'Basketball'])
checkbox("how are you doing?", options=['ok', 'good', 'really good'])
radio("what is you favorite lunch", options=['Taco', 'pizza', 'hamburger'])