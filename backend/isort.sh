#!/bin/sh
echo isort...
isort . --overwrite-in-place --sg **/migrations/*.py
