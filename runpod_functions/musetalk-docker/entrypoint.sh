#!/bin/bash

echo "entrypoint.sh"
whoami
which python
echo "pythonpath" $PYTHONPATH

source /opt/conda/etc/profile.d/conda.sh
conda activate musev
which python
python run.py