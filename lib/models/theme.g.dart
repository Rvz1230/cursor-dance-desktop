// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ThemeItemImpl _$$ThemeItemImplFromJson(Map<String, dynamic> json) =>
    _$ThemeItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      kind: json['kind'] as String? ?? '内置',
      icon: json['icon'] as String? ?? 'Wand2',
      summary: json['summary'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$$ThemeItemImplToJson(_$ThemeItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'kind': instance.kind,
      'icon': instance.icon,
      'summary': instance.summary,
      'description': instance.description,
    };
