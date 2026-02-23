# Dashboard Personal

> [!quote] Meta Diaria
> "La constancia vence a la intensidad."

---

## Áreas de Conocimiento

> [!col]
> ### 🎨 Frontend & Mobile
> [[000_Frontend_and_Mobile_MOC]]

> [!col]
> ### ⚙️ Backend & Languages
> [[000_Backend_and_Languages_MOC]]

> [!col]
> ### ☁️ DevOps & Infra
> [[000_DevOps_and_Infrastructure_MOC]]

> [!col]
> ### 🤖 Embedded & IoT
> [[000_Embedded_and_IoT_MOC]]

> [!col]
> ### 🛡️ Cybersecurity
> [[000_Cybersecurity_MOC]]

---

## Estado Actual

> [!col]
> ### En Progreso
> ```dataview
> LIST
> FROM "Courses"
> WHERE status = "en_progreso" OR !status
> SORT file.mtime DESC
> ```

> [!col]
> ### Completados
> ```dataview
> LIST
> FROM "Courses"
> WHERE status = "completado"
> SORT file.mtime DESC
> ```

> [!col]
> ### Conceptos Recientes
> ```dataview
> LIST
> FROM "Concepto"
> SORT file.ctime DESC
> LIMIT 10
> ```

---

## Roadmaps Activos

```dataview
TABLE WITHOUT ID file.link AS "Roadmap", file.mtime AS "Última Modificación"
FROM "Roadmap" OR "Roadmaps"
SORT file.mtime DESC
```

---

## Inbox / Notas Rápidas
- [[Ideas de Proyectos]]
- [[Pendientes]]

---

> [!tip] Tip de Obsidian
> Usa `Ctrl + P` para abrir la paleta de comandos y busca "Templater" o "Templates" para insertar una nueva plantilla en tus notas.
