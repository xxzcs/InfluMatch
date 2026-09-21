# GDPH&SYSUCC Data Directory

Download the original GDPH&SYSUCC dataset from the
[HoVer-Trans repository](https://github.com/yuhaomo/HoVerTrans) and place it
here before training:

```text
data/GDPH_SYSUCC/
  label.csv
  img/
    <image files>
```

`label.csv` must provide the columns `ID`, `fold`, and `label`. This directory
is ignored by Git. Do not commit or redistribute image data or patient metadata
through this repository.
