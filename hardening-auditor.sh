#!/usr/bin/env 
"""
Hardening Auditor - Herramienta de auditoría de seguridad para Linux
Author: Security Student
Version: 1.0
"""

import os
import json
import subprocess
import datetime
import sys
from pathlib import Path

class HardeningAuditor:
    def __init__(self):
        self.controls_file = "config/controls.json"
        self.results = {
            "timestamp": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            "hostname": os.uname().nodename,
            "system": f"{os.uname().sysname} {os.uname().release}",
            "summary": {"total": 0, "passed": 0, "failed": 0, "error": 0},
            "controls": []
        }
        self.colors = {
            'green': '\033[92m',
            'red': '\033[91m',
            'yellow': '\033[93m',
            'blue': '\033[94m',
            'reset': '\033[0m',
            'bold': '\033[1m'
        }
    
    def check_root(self):
        """Verificar si se ejecuta como root"""
        if os.geteuid() != 0:
            print(f"{self.colors['yellow']}[!] Algunas comprobaciones requieren privilegios root{self.colors['reset']}")
            print(f"{self.colors['yellow']}[!] Ejecuta con 'sudo' para mejores resultados{self.colors['reset']}")
            return False
        return True
    
    def load_controls(self):
        """Cargar controles desde el archivo JSON"""
        try:
            with open(self.controls_file, 'r') as f:
                return json.load(f)
        except FileNotFoundError:
            print(f"{self.colors['red']}[ERROR] No se encuentra el archivo {self.controls_file}{self.colors['reset']}")
            sys.exit(1)
        except json.JSONDecodeError:
            print(f"{self.colors['red']}[ERROR] El archivo JSON no es válido{self.colors['reset']}")
            sys.exit(1)
    
    def run_command(self, command):
        """Ejecutar comando y retornar resultado"""
        try:
            # Para comandos que empiezan con '!', significa que esperamos que fallen
            if command.startswith('!'):
                command = command[1:]
                result = subprocess.run(command, shell=True, capture_output=True, text=True)
                return result.returncode != 0
            else:
                result = subprocess.run(command, shell=True, capture_output=True, text=True)
                return result.returncode == 0
        except Exception as e:
            return False
    
    def audit_section(self, section_name, controls):
        """Auditar una sección de controles"""
        print(f"\n{self.colors['blue']}{self.colors['bold']}[*] Auditing {section_name.replace('_', ' ').title()}{self.colors['reset']}")
        print("-" * 60)
        
        section_results = []
        for control in controls:
            # Ejecutar el check
            status = self.run_command(control['check'])
            
            # Determinar resultado
            if status:
                result_text = f"{self.colors['green']}[PASS]{self.colors['reset']}"
                self.results['summary']['passed'] += 1
                control_status = "PASS"
            else:
                result_text = f"{self.colors['red']}[FAIL]{self.colors['reset']}"
                self.results['summary']['failed'] += 1
                control_status = "FAIL"
            
            self.results['summary']['total'] += 1
            
            # Mostrar resultado
            print(f"{result_text} {control['id']}: {control['description']}")
            
            # Si falló, mostrar remediación
            if not status:
                print(f"     {self.colors['yellow']}→ Remediation: {control['remediation']}{self.colors['reset']}")
            
            # Guardar resultado
            section_results.append({
                "id": control['id'],
                "description": control['description'],
                "status": control_status,
                "severity": control['severity'],
                "remediation": control['remediation'] if not status else ""
            })
        
        return section_results
    
    def generate_report(self, all_results):
        """Generar reporte en archivo"""
        self.results['controls'] = all_results
        
        # Crear nombre de archivo con timestamp
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        report_file = f"reports/audit_{self.results['hostname']}_{timestamp}.json"
        
        # Guardar reporte JSON
        with open(report_file, 'w') as f:
            json.dump(self.results, f, indent=4)
        
        # Generar reporte TXT más legible
        txt_file = f"reports/audit_{self.results['hostname']}_{timestamp}.txt"
        with open(txt_file, 'w') as f:
            f.write("=" * 70 + "\n")
            f.write("HARDENING AUDIT REPORT\n")
            f.write("=" * 70 + "\n\n")
            f.write(f"Hostname: {self.results['hostname']}\n")
            f.write(f"System: {self.results['system']}\n")
            f.write(f"Timestamp: {self.results['timestamp']}\n\n")
            
            f.write("SUMMARY\n")
            f.write("-" * 70 + "\n")
            f.write(f"Total Controls: {self.results['summary']['total']}\n")
            f.write(f"Passed: {self.results['summary']['passed']}\n")
            f.write(f"Failed: {self.results['summary']['failed']}\n")
            f.write(f"Errors: {self.results['summary']['error']}\n\n")
            
            f.write("DETAILED RESULTS\n")
            f.write("-" * 70 + "\n")
            
            for control in self.results['controls']:
                status_symbol = "[PASS]" if control['status'] == "PASS" else "[FAIL]"
                f.write(f"{status_symbol} {control['id']}: {control['description']}\n")
                if control['status'] == "FAIL" and control['remediation']:
                    f.write(f"  → Remediation: {control['remediation']}\n")
            
            f.write("\n" + "=" * 70 + "\n")
            f.write("END OF REPORT\n")
            f.write("=" * 70 + "\n")
        
        return report_file, txt_file
    
    def print_summary(self):
        """Mostrar resumen de la auditoría"""
        print(f"\n{self.colors['blue']}{self.colors['bold']}" + "=" * 60)
        print("AUDIT SUMMARY")
        print("=" * 60 + f"{self.colors['reset']}")
        print(f"Total Controls: {self.results['summary']['total']}")
        print(f"{self.colors['green']}Passed: {self.results['summary']['passed']}{self.colors['reset']}")
        print(f"{self.colors['red']}Failed: {self.results['summary']['failed']}{self.colors['reset']}")
        print(f"Errors: {self.results['summary']['error']}")
    
    def run(self):
        """Ejecutar auditoría completa"""
        print(f"\n{self.colors['blue']}{self.colors['bold']}HARDENING AUDITOR v1.0{self.colors['reset']}")
        print("=" * 60)
        
        # Verificar root
        self.check_root()
        
        # Cargar controles
        controls = self.load_controls()
        
        # Auditar cada sección
        all_results = []
        for section, section_controls in controls.items():
            section_results = self.audit_section(section, section_controls)
            all_results.extend(section_results)
        
        # Mostrar resumen
        self.print_summary()
        
        # Generar reportes
        json_report, txt_report = self.generate_report(all_results)
        print(f"\n{self.colors['green']}[✓] Reportes generados:{self.colors['reset']}")
        print(f"    - JSON: {json_report}")
        print(f"    - TXT: {txt_report}")

def main():
    auditor = HardeningAuditor()
    auditor.run()

if __name__ == "__main__":
    main()
