#!/bin/bash

export PYENV_VIRTUALENV_DISABLE_PROMPT=1
eval "$(pyenv init -)"

pyenv activate foodtruck

pip install -r requirements.txt
