#!/bin/bash

eval "$(pyenv init -)"

pyenv activate foodtruck

pip install -r requirements.txt
