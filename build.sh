#!/bin/bash

export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PIP_REQUIRE_VIRTUALENV=false

eval "$(pyenv init -)"

pyenv activate foodtruck

pip install -r requirements.txt
