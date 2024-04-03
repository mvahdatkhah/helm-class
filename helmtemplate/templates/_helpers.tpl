{{/* Common Labels */}}
{{- define "helmtemplate.labels"}}
    app: nginx
    chartname: {{ .Chart.Name }}
{{- end }}
