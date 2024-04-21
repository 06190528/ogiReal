// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      date: json['date'] as String,
      answer: json['answer'] as String,
      theme: json['theme'] as String,
      good: json['good'] as int,
      cardId: json['cardId'] as String,
    );

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'date': instance.date,
      'answer': instance.answer,
      'theme': instance.theme,
      'good': instance.good,
      'cardId': instance.cardId,
    };
