from enum import Enum
from dataclasses import dataclass, asdict
import flet as ft
from typing import Optional, Callable, Any, List, Union
__all__ = ["FluidAnimation","FluidSpring","CurvedKeyframe","SpringKeyframe", "AnimationProperty"]


class AnimationProperty(Enum):
    TRANSLATE_X = "translateX"
    TRANSLATE_Y = "translateY"
    SCALE = "scale"
    ROTATE = "rotate"
    OPACITY = "opacity"


@dataclass
class FluidSpring:
    dampingFraction: float = 0.5
    duration: float = 0.5



@dataclass
class CurvedKeyframe:
    type: str = "curved"
    value: float = None
    duration: float = None
    curve: Optional[ft.AnimationCurve] = None


@dataclass
class SpringKeyframe:
    type: str = "spring"
    value: float = None
    duration: float = None
    spring: Optional[FluidSpring] = None
    velocity: float = None


@ft.control("FluidAnimation")
class FluidAnimation(ft.ConstrainedControl, ft.AdaptiveControl):
    starting_value: float = 0.0
    keyframes: List[Union[CurvedKeyframe, SpringKeyframe]] = None
    animation_property: AnimationProperty = AnimationProperty.TRANSLATE_X
    content: Optional[ft.Control] = None
    show_duration_label: bool = True
    