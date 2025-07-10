import sys
import os
from django.core.management.base import BaseCommand
from django.conf import settings

class Command(BaseCommand):
    help = 'Inicia el servidor Django con soporte completo para WebSockets usando Daphne'

    def add_arguments(self, parser):
        parser.add_argument('addrport', nargs='?', default='0.0.0.0:8000', help='Opcional dirección IP y puerto; por defecto 0.0.0.0:8000')

    def handle(self, *args, **options):
        # Configurar entorno para ASGI
        os.environ['DJANGO_SETTINGS_MODULE'] = 'pulsera_ansiedad.settings'
        os.environ['DJANGO_ALLOW_ASYNC_UNSAFE'] = 'true'
        
        addrport = options['addrport']
        if ':' in addrport:
            addr, port = addrport.split(':')
        else:
            addr, port = 'localhost', addrport
        
        # Mensaje informativo
        self.stdout.write(self.style.SUCCESS(f'Iniciando servidor Daphne en {addr}:{port}...'))
        self.stdout.write(self.style.SUCCESS('WebSockets habilitados y funcionando'))
        
        try:
            # Usar Daphne para ejecutar el servidor
            from daphne.cli import CommandLineInterface
            CommandLineInterface().run([
                '-b', addr,
                '-p', port,
                'pulsera_ansiedad.asgi:application'
            ])

        except ImportError:
            self.stderr.write(self.style.ERROR('Daphne no está instalado. Instala con: pip install daphne'))
        except Exception as e:
            self.stderr.write(self.style.ERROR(f'Error al iniciar Daphne: {e}'))
