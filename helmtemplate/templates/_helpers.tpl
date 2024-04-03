{{/* Common Labels */}}
{{- define "helmtemplate.labels"}}
    app: nginx
{{- end }}

{{/* k8s Resource Name: String Concat with Hyphen */}}
{{- define "helmbasics.resourceName" }}
{{- printf "%s-%s" .Release.Name .Chart.Name }}
{{- end }}
