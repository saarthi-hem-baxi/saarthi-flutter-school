class Work {
  int? total;
  int? complete;
  int? percentage;

  Work({
    this.total,
    this.complete,
    this.percentage,
  });

  factory Work.fromJson(Map<String, dynamic>? json) => Work(
        total: json?["total"],
        complete: json?["complete"],
        percentage: json?["percentage"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "complete": complete,
        "percentage": percentage,
      };
}
