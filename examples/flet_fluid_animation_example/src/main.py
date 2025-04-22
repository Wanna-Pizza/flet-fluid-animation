import flet as ft

from flet_fluid_animation import FluidAnimation,SpringKeyframe,CurvedKeyframe,FluidSpring


def main(page: ft.Page):
    page.vertical_alignment = ft.MainAxisAlignment.CENTER
    page.horizontal_alignment = ft.CrossAxisAlignment.CENTER

    page.add(FluidAnimation(
        content=ft.Container(width=100,height=100,bgcolor='red'),
        starting_value=0.0,
        keyframes=[
            CurvedKeyframe(value=-100, duration=0.5, curve=ft.AnimationCurve.EASE),
            SpringKeyframe(value=0, 
                           spring=FluidSpring(dampingFraction=0.2,duration=0.5), 
                           velocity=0.1),
            
        ]   
    ))


ft.app(main)
