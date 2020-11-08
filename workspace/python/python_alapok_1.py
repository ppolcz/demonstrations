# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

from sympy import *

i,j = symbols('i j')

print(i*j)

display(Integral(i))

def uppercase_decorator(function):
    def wrapper():
        func = function()
        make_uppercase = func.upper()
        return make_uppercase

    return wrapper


def say_hi():
    return 'hello there'

decorate = uppercase_decorator(say_hi)
print(decorate())

@uppercase_decorator
def say_hi():
    return 'hello there'

print(say_hi())

def decorator_with_arguments(function):
    def wrapper_accepting_arguments(arg1, arg2):
        print("My arguments are: {0}, {1}".format(arg1,arg2))
        function(arg1, arg2)
    return wrapper_accepting_arguments


@decorator_with_arguments
def cities(city_one, city_two):
    print("Cities I love are {0} and {1}".format(city_one, city_two))

print(cities("Nairobi", "Accra"))

from sympy import MatrixSymbol

A = MatrixSymbol('A', 3, 3)