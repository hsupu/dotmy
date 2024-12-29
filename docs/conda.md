
配置国内源

https://docs.conda.io/projects/conda/en/latest/user-guide/configuration/use-condarc.html
https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/

```ps1
conda config --set auto_update_conda False
conda config --set show_channel_urls True
# conda config --set always_yes True

conda config --show channels
conda clean -i

conda install conda-libmamba-solver
conda config --set solver libmamba
```
