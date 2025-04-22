# Introduction

FletFluidAnimation for Flet.

## Examples

```
import flet as ft

from flet_fluid_animation import FletFluidAnimation


def main(page: ft.Page):
    page.vertical_alignment = ft.MainAxisAlignment.CENTER
    page.horizontal_alignment = ft.CrossAxisAlignment.CENTER

    page.add(

                ft.Container(height=150, width=300, alignment = ft.alignment.center, bgcolor=ft.Colors.PURPLE_200, content=FletFluidAnimation(
                    tooltip="My new FletFluidAnimation Control tooltip",
                    value = "My new FletFluidAnimation Flet Control", 
                ),),

    )


ft.app(main)
```

## Classes

[FletFluidAnimation](FletFluidAnimation.md)


