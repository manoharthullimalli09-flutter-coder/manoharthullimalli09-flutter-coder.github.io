import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DownloadResumeUseCase implements UseCase<Unit, NoParams> {
  static const _assetPath = 'assets/resume/Manohar_Thullimalli_Resume.pdf';

  const DownloadResumeUseCase();

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    try {
      // On web, resolve against the current page origin so url_launcher gets
      // a full https:// URL it can open in a new tab.
      // On native, rootBundle-based asset paths don't map to launchable URIs;
      // the resume should be opened via open_filex after extraction — for now
      // the web path is the primary target.
      final uri = kIsWeb ? Uri.base.resolve(_assetPath) : Uri.parse(_assetPath);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure('Could not open resume: $e'));
    }
  }
}
